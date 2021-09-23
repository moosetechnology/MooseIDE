"
""Freeze"" receiving strategy.
Does not trigger any action, as the browser is frozen.
"
Class {
	#name : #MiFreezeMode,
	#superclass : #MiBrowserReceivingMode,
	#category : #'MooseIDE-Core-ReceivingMode'
}

{ #category : #action }
MiFreezeMode class >> browser: aBrowser actOnEntity: anEntity [

	"Do nothing"

	
]

{ #category : #'radio button' }
MiFreezeMode class >> buttonEnabledInBrowser: aBrowser [

	^ true
]

{ #category : #actions }
MiFreezeMode class >> buttonLabel [

	^ 'Freeze'
]

{ #category : #'radio button' }
MiFreezeMode class >> iconInBrowser: aBrowser [

	^ aBrowser canFollow
		  ifTrue: [ MiApplication current iconNamed: #radioButtonUnselected ]
		  ifFalse: [ MiApplication current iconNamed: #radioButtonSelected ]
]
