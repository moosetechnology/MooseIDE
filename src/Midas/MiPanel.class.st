Class {
	#name : #MiPanel,
	#superclass : #SpPresenter,
	#instVars : [
		'models',
		'details'
	],
	#category : #'Midas-Panel'
}

{ #category : #specs }
MiPanel class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #models withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #details
]

{ #category : #specs }
MiPanel class >> open [
	<script>
	self new openWithSpec
]

{ #category : #specs }
MiPanel class >> title [
	^ 'Midas Panel'
]

{ #category : #initialization }
MiPanel >> connectPresenters [
	super connectPresenters models whenActivatedDo: [ :selection | details addPage: (self pageFrom: selection selectedItem) ]
]

{ #category : #initialization }
MiPanel >> initializePresenters [
	models := self newList.
	details := self newNotebook.

	models
		items: MooseModel root asOrderedCollection;
		display: [ :item | item name ]
]

{ #category : #accessing }
MiPanel >> models [
	^ models
]

{ #category : #initialization }
MiPanel >> pageFrom: aModel [
	^ SpNotebookPage title: aModel name provider: [ StInspector on: aModel ]
]
