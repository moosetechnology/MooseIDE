Trait {
	#name : #MiTSpecModelWithSettings,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #testing }
MiTSpecModelWithSettings >> hasSettings [

	^ true
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> newMemento [

	self shouldBeImplemented
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> newMementoForDefaultValues [

	self shouldBeImplemented
]

{ #category : #actions }
MiTSpecModelWithSettings >> openSettings [

	^ (MiSettingsPresenter on: self) openDialog
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> updateFromMemento: aMemento [

	self shouldBeImplemented
]
