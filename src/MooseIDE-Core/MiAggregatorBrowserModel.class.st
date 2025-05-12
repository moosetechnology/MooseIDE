"
The model for the `MiAccumulatorBrowser`
"
Class {
	#name : #MiAggregatorBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'selectedEntities'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #api }
MiAggregatorBrowserModel >> clearEntities [

	entities removeAll.
	selectedEntities removeAll.

	browser updateEntityList: self entities
]

{ #category : #accessing }
MiAggregatorBrowserModel >> entities [
	"converting into an Array because browser Sets have limitations
	 (notably cannot be used as model of an SpListPresenter)"

	^entities asArray
]

{ #category : #initialization }
MiAggregatorBrowserModel >> initialize [

	super initialize.

	entities := Set new.
	selectedEntities := OrderedCollection new

]

{ #category : #accessing }
MiAggregatorBrowserModel >> miSelectedItem [
	"overriden, synonym of #selectedEntities"

	^self selectedEntities
]

{ #category : #'instance creation' }
MiAggregatorBrowserModel >> newEntities: aCollection [

	entities addAll: aCollection.

	browser updateEntityList: self entities
]

{ #category : #api }
MiAggregatorBrowserModel >> numberOfEntities [

	^entities size
]

{ #category : #api }
MiAggregatorBrowserModel >> numberOfSelectedEntities [

	^selectedEntities size
]

{ #category : #api }
MiAggregatorBrowserModel >> removeSelectedEntities [

	entities removeAll: selectedEntities.
	selectedEntities removeAll.

	browser updateEntityList: self entities
]

{ #category : #accessing }
MiAggregatorBrowserModel >> selectedEntities [

	^selectedEntities
]

{ #category : #accessing }
MiAggregatorBrowserModel >> selectedEntities: aCollection [

	selectedEntities := aCollection asOrderedCollection.

	browser updateStatusBar
]
