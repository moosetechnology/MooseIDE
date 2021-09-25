"
""Follow"" receiving strategy.
Triggers a follow action if the browser can receive the current entity.
"
Class {
	#name : #MiFollowMode,
	#superclass : #MiBrowserReceivingMode,
	#category : #'MooseIDE-Core-ReceivingMode'
}

{ #category : #action }
MiFollowMode class >> browser: aBrowser actOnEntity: anEntity [

	(aBrowser canReceiveEntity: anEntity) ifFalse: [ ^ self ].
	^ aBrowser followEntity: anEntity
]

{ #category : #'radio button' }
MiFollowMode class >> buttonEnabledInBrowser: aBrowser [

	^ aBrowser canFollow
]

{ #category : #actions }
MiFollowMode class >> buttonLabel [

	^ 'Follow'
]
