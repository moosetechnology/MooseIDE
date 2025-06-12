Class {
	#name : #MiPropertyExtension,
	#superclass : #SpPresenter,
	#instVars : [
		'inspectedObject'
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
		addColumn: (SpStringTableColumn new
				 title: 'Properties';
				 width: 200;
				 evaluated: [ :item | item name ]) yourself;
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :item |
					 [ inspectedObject mmGetProperty: item ]
						 on: Error
						 do: [ 'error' ] ]);
		items:
			(inspectedObject mooseDescription allPrimitiveProperties sorted:
				 #name ascending);
		beResizable
]

{ #category : #'accessing - model' }
MiPropertyExtension >> setModelBeforeInitialization: aModel [

	inspectedObject := aModel
]
