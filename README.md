# JsonToCSV

JsonToCSV is a Pharo library to transform JSON files and convert them into CSV files.
This library takes care of converting tree-like JSON structures and convert them into a flat record-like structure

## Some examples

- A simple object

```
{
  "x": 1,
  "y: 2
}
```
=>

```
"x","y"
1,2
```

- Heterogeneous objects

```
[{
  "x": 1,
  "y: 2
},{
  "x": 1,
  "z": 3
}]
```
=>

```
"x","y","z"
1,2,
1,,3
```


- Nested objects

```
{
  "x": 1,
  "y: { "w": 28, "z": 90 }
}
```
=>

```
"x","y_w","y_z"
1,28,90
```

- lists are denormalized into different rows by default


```
{
  "x": 1,
  "y: [1, 2, 3]
}
```
=>

```
"x","y"
1,1
1,2
1,3
```

- lists can be normalized into fields in a single row


```
{
  "x": 1,
  "y: [1, 2, 3]
}
```
=>

```
"x","y_1","y_2","y_3"
1,1,2,3
```

## Installation

You can load JsonToCSV using Metacello

```Smalltalk
Metacello new
  repository: 'github://guillep/JsonToCSV/src';
  baseline: 'JsonToCSV';
  load.
```

## Usage

## Licence

MIT Licensed
