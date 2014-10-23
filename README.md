# travap
simple map to show images from journeys placed on a map

## development
* clone
* `npm install`
* `npm start`
* alternative with `PORT=5555 npm start`

## included REST-API
### all places
Fetch all available places
```
/places
```
```json
{
  "coordinates": "<coordinates>",
  "description": "<description>",
  "amount": <amount>,
  "name": "<name>",
  "id": "<id>"
}
```

### one place
Fetch one place with all images
```
/places/:id
```
```json
{
  "coordinates": "<coordinates>",
  "description": "<description>",
  "amount": <amount>,
  "name": "<name>",
  "id": "<id>",
  "images": [<images>]
}
```

## folder structure for places
sort images in folders and add a `info.json` for describing the place

### file structure `info.json`
```json
{
  "coordinates": {
    "lat": <lat>,
    "lng": <lng>
  },
  "description": "",
  "begin": "",
  "end": ""
}
```
OPTIONAL
```json
{
  "name": ""
}
```

### basic file structure
```
places
  |- <place>
    |- info.json(required)
    |- <image>
    |- <image>
    |- ...
  |- <place>
    |- info.json(required)
    |- <image>
    |- <image>
    |- ...
  |- ...
```
