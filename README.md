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
  coordinates: "<coordinates>",
  description: "<description>",
  amount: <amount>,
  name: "<name>",
  id: "<id>"
}
```

### one place
Fetch one place with all images
```
/places/:id
```
```
{
  coordinates: "<coordinates>",
  description: "<description>",
  amount: <amount>,
  name: "<name>",
  id: "<id>"
  images: [<images>]
}
```

## folder structure for places
sort images in folders and add a `info.json` for describe the place

### file structure `info.json`
```json
{
  "coordinates": "",
  "description": "",
  "begin": "",
  "end": ""
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