"
The model for the `MiAccumulatorBrowser`
"
Class {
	#name : #MiAccumulatorBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'selectedEntities'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #api }
MiAccumulatorBrowserModel >> clearEntities [

	entities removeAll.
	selectedEntities removeAll.

	browser updateEntityList: self entities
]

{ #category : #accessing }
MiAccumulatorBrowserModel >> entities [
	"converting into an Array because browser Sets have limitations
	 (notably cannot be used as model of an SpListPresenter)"

	^entities asArray
]

{ #category : #initialization }
MiAccumulatorBrowserModel >> initialize [

	super initialize.

	entities := Set new.
	selectedEntities := OrderedCollection new

]

{ #category : #accessing }
MiAccumulatorBrowserModel >> miSelectedItem [
	"overriden, synonym of #selectedEntities"

	^self selectedEntities
]

{ #category : #'instance creation' }
MiAccumulatorBrowserModel >> newEntities: aCollection [

	entities addAll: aCollection.

	browser updateEntityList: self entities
]

{ #category : #api }
MiAccumulatorBrowserModel >> numberOfEntities [

	^entities size
]

{ #category : #api }
MiAccumulatorBrowserModel >> numberOfSelectedEntities [

	^selectedEntities size
]

{ #category : #api }
MiAccumulatorBrowserModel >> removeSelectedEntities [

	entities removeAll: selectedEntities.
	selectedEntities removeAll.

	browser updateEntityList: self entities
]

{ #category : #accessing }
MiAccumulatorBrowserModel >> selectedEntities [

	^selectedEntities
]

{ #category : #accessing }
MiAccumulatorBrowserModel >> selectedEntities: aCollection [

	selectedEntities := aCollection asOrderedCollection.

	browser updateStatusBar
]
