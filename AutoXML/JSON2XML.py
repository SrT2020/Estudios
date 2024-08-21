import argparse
from json2xml import json2xml
from json2xml.utils import readfromurl

# Configurar argparse para manejar argumentos de línea de comandos
parser = argparse.ArgumentParser(description='Convert JSON from a URL to XML and save it to a file.')
parser.add_argument('url', type=str, help='The URL of the JSON data')
parser.add_argument('output_file', type=str, help='The name of the output XML file')

args = parser.parse_args()

# Obtener los datos JSON desde la URL pasada como argumento y convertirlos a XML
data = readfromurl(args.url)
content = json2xml.Json2xml(data).to_xml()

# Escribir el contenido XML en el archivo especificado
with open(args.output_file, 'w') as f:
    f.write(content)
