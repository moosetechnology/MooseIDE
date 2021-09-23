"
""Highlight"" receiving strategy.
Triggers a highlight action if the browser can receive the current entity.
"
Class {
	#name : #MiHighlightMode,
	#superclass : #MiBrowserReceivingMode,
	#category : #'MooseIDE-Core-ReceivingMode'
}

{ #category : #action }
MiHighlightMode class >> browser: aBrowser actOnEntity: anEntity [

	(aBrowser canReceiveEntity: anEntity) ifFalse: [ ^ self ].
	^ aBrowser highlightEntity: anEntity
]

{ #category : #'radio button' }
MiHighlightMode class >> buttonEnabledInBrowser: aBrowser [

	^ aBrowser canHighlight
]

{ #category : #actions }
MiHighlightMode class >> buttonLabel [

	^ 'Highlight'
]

{ #category : #'radio button' }
MiHighlightMode class >> iconInBrowser: aBrowser [

	^ MiApplication current iconNamed: #radioButtonUnselected
]
