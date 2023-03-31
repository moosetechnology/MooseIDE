Class {
	#name : #MiPropertyExtension,
	#superclass : #SpPresenter,
	#instVars : [
		'properties',
		'model'
	],
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #specs }
MiPropertyExtension class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #properties;
		  yourself
]

{ #category : #initialization }
MiPropertyExtension >> initializePresenters [

	properties := self newTable.
	properties
		addColumn: (SpStringTableColumn
				 title: 'Properties'
				 evaluated: [ :item | item name ]) yourself;
		addColumn:
			(SpStringTableColumn title: 'Value' evaluated: [ :item | 
					 [ self model mmGetProperty: item ]
						 on: Error
						 do: [ 'error' ] ]);
		items: (self model mooseDescription allPrimitiveProperties sorted:
					 #name ascending);
		beResizable
]

{ #category : #accessing }
MiPropertyExtension >> model [
	^ model
]

{ #category : #accessing }
MiPropertyExtension >> model: anObject [
	model := anObject.
	properties ifNotNil: [ :p | p items: model mooseDescription allPrimitiveProperties ]
]

{ #category : #'accessing - model' }
MiPropertyExtension >> setModelBeforeInitialization: aModel [
	self model: aModel
]
