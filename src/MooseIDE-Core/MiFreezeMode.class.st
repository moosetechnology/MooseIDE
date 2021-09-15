"
""Freeze"" receiving strategy.
Does not trigger any action, as the browser is frozen.
"
Class {
	#name : #MiFreezeMode,
	#superclass : #MiBrowserReceivingMode,
	#category : #'MooseIDE-Core-BrowseAction'
}

{ #category : #action }
MiFreezeMode class >> browser: aBrowser actOnEntity: anEntity [

	"Do nothing"

	
]

{ #category : #testing }
MiFreezeMode class >> isFreeze [

	^ true
]
