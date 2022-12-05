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

	columns add: (MiExportPropertyColumnModel forProperty: aFM3Property)
]

{ #category : #'api - column script' }
MiExportModel >> addColumnForQuery: aBlock withName: queryName [

	columns add: (MiExportQueryColumnModel new
			 query: aBlock;
			 name: queryName;
			 yourself)
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
MiExportModel >> initialize [
	super initialize.
	commentDictionary := Dictionary new.
	columns := OrderedCollection new
]

{ #category : #'api - column property' }
MiExportModel >> removeColumnForProperty: aFM3Property [

	columns removeAllSuchThat: [ :column | 
		(column isKindOf: MiExportPropertyColumnModel) and: [ 
			column property = aFM3Property ] ]
]

{ #category : #'api - column script' }
MiExportModel >> removeColumnForQueryNamed: queryName [

	columns removeAllSuchThat: [ :column | 
		(column isKindOf: MiExportQueryColumnModel) and: [ 
			column name = queryName ] ]
]
