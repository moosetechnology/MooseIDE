Class {
	#name : #MiPlaygroundBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'playground'
	],
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #'instance creation' }
MiPlaygroundBrowser class >> open [

	<script>
	^ super open
]

{ #category : #testing }
MiPlaygroundBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #testing }
MiPlaygroundBrowser >> canPropagate [

	^ true
]

{ #category : #layout }
MiPlaygroundBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: playground;
		  yourself
]

{ #category : #initialization }
MiPlaygroundBrowser >> initializePresenters [

	super initializePresenters.
	playground := self instantiate: MiPlayground
]

{ #category : #accessing }
MiPlaygroundBrowser >> miSelectedItem [

	| codePresenter result |
	
	codePresenter := playground firstPage text.

	^ result := codePresenter
		            evaluate: codePresenter selectedTextOrLine
		            onCompileError: [ :e | ^ self ]
		            onError: [ :e | e pass ]
]
