Class {
	#name : #MiTestingBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'list',
		'button',
		'toolbar'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #'instance creation' }
MiTestingBrowser class >> open [

	<script>
	self new
		addStyle: 'mooseContainer';
		open
]

{ #category : #initialization }
MiTestingBrowser >> initializePresenters [

	super initializePresenters.
	list := self newList.
	button := self newButton label: 'Button'.
	toolbar := self newToolbar.

	self layout: (SpBoxLayout newTopToBottom
			 add: toolbar height: self class toolbarHeight;
			 add: button;
			 add: list;
			 yourself)
]
