Class {
	#name : #MiPropertyBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'properties',
		'model'
	],
	#category : #Midas
}

{ #category : #specs }
MiPropertyBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #properties
]

{ #category : #initialization }
MiPropertyBrowser >> initializePresenters [
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
MiPropertyBrowser >> model [
	^ model
]

{ #category : #accessing }
MiPropertyBrowser >> model: anObject [
	model := anObject
]

{ #category : #initialization }
MiPropertyBrowser >> setModelBeforeInitialization: aModel [
	self model: aModel
]
