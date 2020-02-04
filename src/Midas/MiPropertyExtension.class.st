Class {
	#name : #MiPropertyExtension,
	#superclass : #SpPresenter,
	#instVars : [
		'properties',
		'model'
	],
	#category : #'Midas-Inspector'
}

{ #category : #specs }
MiPropertyExtension class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #properties
]

{ #category : #initialization }
MiPropertyExtension >> initializePresenters [
	properties := self newTable.
	properties
		addColumn: (SpStringTableColumn title: 'Properties' evaluated: [ :item | item name ]) yourself;
		addColumn:
			(SpStringTableColumn
				title: 'Value'
				evaluated: [ :item | 
					[ self model mmGetProperty: item ]
						on: Error
						do: [ 'error' ] ]);
		items: self model mooseDescription allPrimitiveProperties;
		beResizable
]

{ #category : #accessing }
MiPropertyExtension >> model [
	^ model
]

{ #category : #accessing }
MiPropertyExtension >> model: anObject [
	model := anObject
]

{ #category : #initialization }
MiPropertyExtension >> setModelBeforeInitialization: aModel [
	self model: aModel
]
