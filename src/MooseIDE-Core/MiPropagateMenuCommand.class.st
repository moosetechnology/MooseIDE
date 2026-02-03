Class {
	#name : 'MiPropagateMenuCommand',
	#superclass : 'MiCommand',
	#category : 'MooseIDE-Core-Command',
	#package : 'MooseIDE-Core',
	#tag : 'Command'
}

{ #category : 'default' }
MiPropagateMenuCommand class >> defaultDescription [

	^ 'Select the tag that will be used to tag the current entities in this browser'
]

{ #category : 'default' }
MiPropagateMenuCommand class >> defaultIconName [

	^ #mooseOutgoing
]

{ #category : 'default' }
MiPropagateMenuCommand class >> defaultName [

	^ 'Send to...'
]

{ #category : 'testing' }
MiPropagateMenuCommand >> canBeExecuted [

	^ self context canPropagate
]

{ #category : 'executing' }
MiPropagateMenuCommand >> execute [

	(MiAbstractBrowser allBrowsersMenuRoot: SpMenuPresenter new
		  action: [ :browserClass | self propagateToBrowser: browserClass ]) openWithSpecAtPointer
]

{ #category : 'executing' }
MiPropagateMenuCommand >> propagateToBrowser: browserClass [

	| selectedItem |
	selectedItem := [ self context miSelectedItemToPropagate ]
		on: MiNoSelectedElementToPropagateException
		do: [ :exception |
			exception signal.
			^ self ].

	browserClass openOn: selectedItem

]
