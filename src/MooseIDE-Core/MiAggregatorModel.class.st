"
The model for the `MiAccumulatorBrowser`
"
Class {
	#name : 'MiAggregatorModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'selectedEntities'
	],
	#category : 'MooseIDE-Core-Logger',
	#package : 'MooseIDE-Core',
	#tag : 'Logger'
}

{ #category : 'api' }
MiAggregatorModel >> clearEntities [

	entities removeAll.
	selectedEntities removeAll.

	browser updateEntityList: self entities
]

{ #category : 'accessing' }
MiAggregatorModel >> entities [
	"converting into an Array because browser Sets have limitations
	 (notably cannot be used as model of an SpListPresenter)"

	^entities asArray
]

{ #category : 'initialization' }
MiAggregatorModel >> initialize [

	super initialize.

	entities := Set new.
	selectedEntities := OrderedCollection new

]

{ #category : 'accessing' }
MiAggregatorModel >> miSelectedItem [
	"overriden, synonym of #selectedEntities"

	^self selectedEntities
]

{ #category : 'instance creation' }
MiAggregatorModel >> newEntities: aCollection [

	entities addAll: aCollection.

	browser updateEntityList: self entities
]

{ #category : 'api' }
MiAggregatorModel >> numberOfEntities [

	^entities size
]

{ #category : 'api' }
MiAggregatorModel >> numberOfSelectedEntities [

	^selectedEntities size
]

{ #category : 'api' }
MiAggregatorModel >> removeSelectedEntities [

	entities removeAll: selectedEntities.
	selectedEntities removeAll.

	browser updateEntityList: self entities
]

{ #category : 'accessing' }
MiAggregatorModel >> selectedEntities [

	^selectedEntities
]

{ #category : 'accessing' }
MiAggregatorModel >> selectedEntities: aCollection [

	selectedEntities := aCollection asOrderedCollection.

	browser updateStatusBar
]
