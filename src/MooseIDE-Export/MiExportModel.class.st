"
## Scripting usages

```st
mooseModel := MooseModel root at: 1.

exportBrowser := MiExportBrowser new.
exportBrowserModel := MiExportModel new.

exportBrowser model: exportBrowserModel.

exportBrowser open.
exportBrowser followEntity: mooseModel.

exportBrowserModel addColumnForQuery: 
	[ :entity | 'hello world' ]
	withName: #HelloWorld.

exportBrowser updateTable.

exportBrowserModel removeColumnForQueryNamed: #HelloWorld.
```
"
Class {
	#name : #MiExportModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entitiesList',
		'commentDictionary',
		'columns'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #'api - column property' }
MiExportModel >> addColumnForProperty: aFM3Property [

	self columnAdded:
		(columns add:
			 (MiExportPropertyColumnModel forProperty: aFM3Property))
]

{ #category : #'api - column script' }
MiExportModel >> addColumnForQuery: aBlock withName: queryName [

	| newColumn |
	newColumn := columns add: (MiExportQueryColumnModel new
			              query: aBlock;
			              name: queryName;
			              yourself).
	self columnAdded: newColumn.
	^ newColumn
]

{ #category : #events }
MiExportModel >> columnAdded: aColumn [

	self browser ifNotNil: [ :b | b columnAdded: aColumn ]
]

{ #category : #events }
MiExportModel >> columnRemoved: aColumn [

	self browser ifNotNil: [ :b | b columnRemoved: aColumn ]
]

{ #category : #accessing }
MiExportModel >> columns [

	^ columns
]

{ #category : #accessing }
MiExportModel >> columns: anObject [

	columns := anObject
]

{ #category : #api }
MiExportModel >> comment: anEntity with: aCommentString [

	^ commentDictionary at: anEntity put: aCommentString
]

{ #category : #api }
MiExportModel >> commentOf: anEntity [

	^ commentDictionary at: anEntity ifAbsent: ''
]

{ #category : #initialization }
MiExportModel >> defaultColumns [

	^ { 
		  (MiExportQueryColumnModel new
			   query: [ :entity | 
				   String streamContents: [ :s | entity displayStringOn: s ] ];
			   name: #Name;
			   yourself).
		  (MiExportQueryColumnModel new
			   query: [ :entity | entity mooseDescription name ];
			   name: #Type;
			   yourself) } asOrderedCollection
]

{ #category : #accessing }
MiExportModel >> entities [
	^self entitiesList 
]

{ #category : #accessing }
MiExportModel >> entitiesList [

	^ entitiesList
]

{ #category : #accessing }
MiExportModel >> entitiesList: anObject [

	entitiesList := anObject.
	self listEntityChanged
]

{ #category : #initialization }
MiExportModel >> initialize [
	super initialize.
	commentDictionary := Dictionary new.
	columns := self defaultColumns.
	entitiesList := OrderedCollection new
]

{ #category : #events }
MiExportModel >> listEntityChanged [

	self browser ifNotNil: [ :b | b listEntityChanged ]
]

{ #category : #'api - column property' }
MiExportModel >> removeColumnForProperty: aFM3Property [

	(columns removeAllSuchThat: [ :column | 
		 (column isKindOf: MiExportPropertyColumnModel) and: [ 
			 column property = aFM3Property ] ]) do: [ :removed | 
		self columnRemoved: removed ]
]

{ #category : #'api - column script' }
MiExportModel >> removeColumnForQueryNamed: queryName [

	(columns removeAllSuchThat: [ :column | 
		 (column isKindOf: MiExportQueryColumnModel) and: [ 
			 column name = queryName ] ]) do: [ :removed | 
		self columnRemoved: removed ]
]

{ #category : #'api - export' }
MiExportModel >> writeCSVOn: aStream [

	| csvWriter |
	csvWriter := NeoCSVWriter on: aStream.
	csvWriter writeHeader:
		(self columns collect: [ :column | column name ]).
	self columns do: [ :column | 
		csvWriter addField: [ :item | column printValueFor: item ] ].
	csvWriter nextPutAll: self entitiesList
]
