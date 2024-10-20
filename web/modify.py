with open("index.html",encoding='utf-8') as f:
    content=f.read()
with open("index.html","w",encoding='utf-8') as f:
    f.write(content.replace("/Shape_Weather/","/"))