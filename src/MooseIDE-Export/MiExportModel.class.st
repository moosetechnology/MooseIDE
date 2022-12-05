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

{ #category : #api }
MiExportModel >> addColumnForProperty: aFM3Property [

	columns add: (MiExportPropertyColumnModel forProperty: aFM3Property)
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

{ #category : #api }
MiExportModel >> removeColumnForProperty: aFM3Property [

	columns removeAllSuchThat: [ :column | 
		(column isKindOf: MiExportPropertyColumnModel) and: [ 
			column property = aFM3Property ] ]
]
