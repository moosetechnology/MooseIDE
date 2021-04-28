Class {
	#name : #MiMooseInspectorBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'millerList'
	],
	#category : #'Midas-NewTools-Inspector'
}

{ #category : #specs }
MiMooseInspectorBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #millerList;
		  yourself
]

{ #category : #'instance creation' }
MiMooseInspectorBrowser class >> runMe [

	<script>
	^ super runMe
]

{ #category : #actions }
MiMooseInspectorBrowser >> followAction [

	"for now lets do nothing"
	
]

{ #category : #initialization }
MiMooseInspectorBrowser >> initializePresenters [

	super initializePresenters.
	millerList := self instantiate: StInspector
]
