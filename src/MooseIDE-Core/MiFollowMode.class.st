"
""Follow"" receiving strategy.
Triggers a follow action if the browser can receive the current entity.
"
Class {
	#name : #MiFollowMode,
	#superclass : #MiBrowserReceivingMode,
	#category : #'MooseIDE-Core-BrowseAction'
}

{ #category : #action }
MiFollowMode class >> browser: aBrowser actOnEntity: anEntity [

	(aBrowser canReceiveEntity: anEntity) ifFalse: [ ^ self ].
	^ aBrowser followEntity: anEntity
]
