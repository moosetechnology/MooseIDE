Class {
	#name : #MiTestingBrowser2,
	#superclass : #MiPresenter,
	#instVars : [
		'inner'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #'instance creation' }
MiTestingBrowser2 class >> open [

	<script>
	self new open
]

{ #category : #initialization }
MiTestingBrowser2 >> initializePresenters [

	super initializePresenters.

	inner := self instantiate: MiTestingBrowser.
	self layout: (SpBoxLayout newTopToBottom
			 add: inner;
			 yourself).
	inner addStyle: 'mooseContainer'
]
