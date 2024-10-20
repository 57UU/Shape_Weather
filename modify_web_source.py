src="https://shape-weather.pages.dev/"
path="./build/web/index.html"
files=["main.dart.js","main.dart.mjs","main.dart.wasm"]
with open(path,encoding='utf-8') as f:
    content=f.read()

for i in files:
    content=content.replace(i,src+i)

with open(path,"w",encoding='utf-8') as f:
    f.write(content)