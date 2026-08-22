docker run -d --name=redis redis                  # in memory data store db
docker run -d --name=db postgres:9.4              # backend db
docker run -d --name=vote -p 5000:80 voting-app    # Python voting app
docker run -d --name=result -p 5001:80 result-app  # node.js app to build webpage to show results
docker run -d --name=worker worker                 # .NET app background service