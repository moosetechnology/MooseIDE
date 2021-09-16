"
""Highlight"" receiving strategy.
Triggers a highlight action if the browser can receive the current entity.
"
Class {
	#name : #MiHighlightMode,
	#superclass : #MiBrowserReceivingMode,
	#category : #'MooseIDE-Core-BrowseAction'
}

{ #category : #action }
MiHighlightMode class >> browser: aBrowser actOnEntity: anEntity [

	(aBrowser canReceiveEntity: anEntity) ifFalse: [ ^ self ].
	^ aBrowser highlightEntity: anEntity
]
