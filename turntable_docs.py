from subprocess import run
import yaml
import openai
from timeit import default_timer as timer
import sys
import os
from pathlib import Path

# openai.api_key = os.getenv("OPENAI_API_KEY")
openai.api_key = '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'

def ai_completion(text_prompt):
    return openai.Completion.create(
        model="text-davinci-003",
        prompt=text_prompt,
        temperature=0,
        max_tokens=500,
        top_p=1,
        frequency_penalty=0,
        presence_penalty=0
    )

def build_prompt_for_column_descriptions(sql_query, column_names):
    return """
{sql_query}

write a descriptions for each column of the table: {column_names}
{column_names[0]}: """.format(sql_query=sql_query, column_names=column_names)

def build_prompt_for_table_summary(sql_query):
    return """
{sql_query}

write a detailed summary for this table for a business executive

summary: """.format(sql_query=sql_query)


def generate_schema_file(path, model_names):
    model_names_str_template = ','.join(['\"' + name + '\"' for name in model_names])
    generate_command = 'dbt run-operation generate_model_yaml --args \'{"model_names":'
    generate_command += ' [' + model_names_str_template +']}\''
    output = run(
        generate_command,
        capture_output=True,
        shell=True
    )
    if output.returncode == 0:
        contents = output.stdout.decode('utf-8')
        contents = contents.split('models:')[1]
        contents = 'version: 2\nmodels:' + contents
        with open(f'{path}/.schema.turntable.yml', 'w+') as f:
            f.write(contents)
            print(f'✅ generated schema file at {path}/.schema.turntable.yml')
        
        return f'{path}/.schema.turntable.yml'
    return None


def generate_documentation_for_models(schema_file_path):
    with open(schema_file_path, 'r') as schema_file:
        contents = schema_file.read()
        schema_data = yaml.safe_load(contents)
        # print(data)
    for model in schema_data['models']:
        column_names = [col['name'] for col in model['columns']]
        # print(column_names)
        models_file_path = schema_file_path.split('/.schema.turntable.yml')[0]
        model_name = model['name']
        with open(f'{models_file_path}/{model_name}.sql', 'r') as sql_file:
            sql_query = sql_file.read()
            prompt = build_prompt_for_column_descriptions(sql_query, column_names)
            # print(prompt)
        response = ai_completion(prompt)
        documented_columns = f'{column_names[0]}:' + response['choices'][0]['text']
        # print(documented_columns)
        column_description_pair = documented_columns.split('\n')

        for pair in column_description_pair:
            if pair.strip() == '':
                print('error: blank pair')
                continue
            # sometimes open ai returns a wierd newline for the description
            try: 
                if len(pair.split(':\n')) == 2:
                    column_name, description = pair.split(':\n')
                else:
                    column_name, description = pair.split(':')
            except ValueError as e:
                print('error: getting description for pair ', pair)
                continue
            column_name = column_name.strip()
            description = description.strip()
            model['columns'][column_names.index(column_name)]['description'] = description
            for column in model['columns']:
                if column['name'] == column_name:
                    column['description'] = description
        
        
        table_summary_prompt = build_prompt_for_table_summary(sql_query)
        response = ai_completion(table_summary_prompt)
        summary = response['choices'][0]['text'].strip()
        model['description'] = summary
        print(f'🤖 wrote documentation for {model_name}')
    
    with open(schema_file_path, 'w+') as schema_file:
        yaml.dump(schema_data, schema_file, sort_keys=False)
        
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Please provide the filepath to your dbt project models directory')
        print('usage: python turntable_docs.py /path/to/dbt/project/models')
        exit(1)
    print(r"""
  _                    _        _     _      
 | |_ _   _ _ __ _ __ | |_ __ _| |__ | | ___ 
 | __| | | | '__| '_ \| __/ _` | '_ \| |/ _ \
 | |_| |_| | |  | | | | || (_| | |_) | |  __/
  \__|\__,_|_|  |_| |_|\__\__,_|_.__/|_|\___|                                       
    """)
    start = timer()
    model_path = sys.argv[1]
    path = Path(model_path)
    for walk in os.walk(path):
        file_path, dirs, files = walk
        if len(files) == 0:
            continue        
        sql_files = [file for file in files if file.endswith('.sql')]
        if 0 < len(sql_files):
            # this assumes everyting will be x.sql where x doesnt contain any periods
            model_names = [file.split('.')[0] for file in sql_files]
            print(file_path)
            print(f'📝 documenting models: {model_names}')
            schema_file = generate_schema_file(file_path, model_names)
            generate_documentation_for_models(schema_file)
    elapsed = timer() - start
    print(f'Generated documentation for project in {elapsed} seconds')
    exit(0)



