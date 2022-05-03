Class {
	#name : #MiDuplicationSettingsBrowser,
	#superclass : #SpPresenter,
	#instVars : [
		'txtNumberOfReplicas',
		'txtNumberOfLines',
		'txtNumberOfCharacters',
		'lstCleanerClass',
		'txtNumberReplicasShowed',
		'btnOk',
		'btnCancel',
		'settingsModel'
	],
	#category : #'MooseIDE-Duplication'
}

{ #category : #accessing }
MiDuplicationSettingsBrowser class >> title [
	^'Duplication browser settings'
]

{ #category : #specs }
MiDuplicationSettingsBrowser class >> windowSize [
	^ 400@200
]

{ #category : #actions }
MiDuplicationSettingsBrowser >> abortSettings [
	self window close.
]

{ #category : #actions }
MiDuplicationSettingsBrowser >> acceptSettings [
	settingsModel minNumberOfLines: txtNumberOfLines text asInteger.
	settingsModel minNumberOfReplicas: txtNumberOfReplicas text asInteger.
	settingsModel minNumberOfCharacters: txtNumberOfCharacters text asInteger.
	settingsModel maxReplicasShowed: txtNumberReplicasShowed text asInteger.

	settingsModel codeCleanerClass: lstCleanerClass selectedItem.
	
	self window close
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> btnCancel [

	^ btnCancel
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> btnCancel: anObject [

	btnCancel := anObject
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> btnOk [

	^ btnOk
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> btnOk: anObject [

	btnOk := anObject
]

{ #category : #accessing }
MiDuplicationSettingsBrowser >> helpListOfCleaners [
	^'The cleaner used to clean the code before detecting duplication. The cleaner removes extra whitespaces and/or comments. Cleaners are programming language specific.'
]

{ #category : #accessing }
MiDuplicationSettingsBrowser >> helpNumberOfCharacters [
	^'Minimum number of characters in duplicated fragment. Code fragments that are too small are not interesting.'
]

{ #category : #accessing }
MiDuplicationSettingsBrowser >> helpNumberOfLines [
	^'Minimum number of lines of code in a duplicated code snipet. The larger, the less duplicated snippets found.'
]

{ #category : #accessing }
MiDuplicationSettingsBrowser >> helpNumberOfReplicas [
	^'The minimum number of times a code snippet is duplicated. Cannot be less than 2. The larger, the less duplicated snippets found.'
]

{ #category : #accessing }
MiDuplicationSettingsBrowser >> helpNumberOfReplicasShowed [
	^'Maximum number of entities shown in the browser. If a code snippet is duplicated too many times, will only show that much occurences.'
]

{ #category : #initialization }
MiDuplicationSettingsBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: 'Minimum number of character' ;
			add: txtNumberOfCharacters ;
			yourself ) ;
		add: (SpBoxLayout newLeftToRight
			add: 'Minimum number of line' ;
			add: txtNumberOfLines ;
			yourself );
		add: (SpBoxLayout newLeftToRight
			add: 'Minimum number of replica' ;
			add: txtNumberOfReplicas ;
			yourself ) ;
		add: (SpBoxLayout newLeftToRight
			add: 'Code cleaning startegy' ;
			add: lstCleanerClass ;
			yourself ) ;
		add: (SpBoxLayout newLeftToRight
			add: btnOk ;
			add: btnCancel ;
			yourself ) ;
		yourself)
]

{ #category : #initialization }
MiDuplicationSettingsBrowser >> initializePresenter [ 
	super initializePresenter.

	txtNumberOfReplicas := self newText
		text: settingsModel minNumberOfReplicas asString ;
		help: self helpNumberOfReplicas ;
		yourself.
	txtNumberOfLines := self newText
		text: settingsModel minNumberOfLines asString ;
		help: self helpNumberOfLines ;
		yourself.
	txtNumberOfCharacters := self newText
		text: settingsModel minNumberOfCharacters asString ;
		help: self helpNumberOfCharacters ;
		yourself.
	txtNumberReplicasShowed := self newText
		text: settingsModel maxReplicasShowed asString ;
		help: self helpNumberOfReplicasShowed ;
		yourself.

	lstCleanerClass := self newDropList
		items: FamixRepSourcesCleaner allAvailableCleaners ;
		display: [ :cleaner | cleaner displayString ] ;
		selectItem: settingsModel codeCleanerClass ;
		help: self helpListOfCleaners ;
		yourself.

	btnOk := self newButton
		label: 'OK' ;
		action: [ self acceptSettings ] ;
		yourself.
	btnCancel := self newButton
		label: 'Cancel' ;
		action: [ self abortSettings ] ;
		yourself.
	
	self initializeLayout
]

{ #category : #initialization }
MiDuplicationSettingsBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter initialExtent: self class windowSize
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> lstCleanerClass [

	^ lstCleanerClass
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> lstCleanerClass: anObject [

	lstCleanerClass := anObject
]

{ #category : #initialization }
MiDuplicationSettingsBrowser >> setModelBeforeInitialization: model [
	settingsModel := model
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> settingsModel [

	^ settingsModel
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberOfCharacters [

	^ txtNumberOfCharacters
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberOfCharacters: anObject [

	txtNumberOfCharacters := anObject
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberOfLines [

	^ txtNumberOfLines
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberOfLines: anObject [

	txtNumberOfLines := anObject
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberOfReplicas [

	^ txtNumberOfReplicas
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberOfReplicas: anObject [

	txtNumberOfReplicas := anObject
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberReplicasShowed [

	^ txtNumberReplicasShowed
]

{ #category : #'accessing - tests' }
MiDuplicationSettingsBrowser >> txtNumberReplicasShowed: anObject [

	txtNumberReplicasShowed := anObject
]
