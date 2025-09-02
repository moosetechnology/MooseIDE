Class {
	#name : 'MiCodeCleanerSettingPresenter',
	#superclass : 'MiAbstractRadioButtonSettingPresenter',
	#category : 'MooseIDE-Duplication',
	#package : 'MooseIDE-Duplication'
}

{ #category : 'accessing' }
MiCodeCleanerSettingPresenter class >> help [

	^ 'Cleaner used to clean the code before detecting duplication.
The cleaner removes extra whitespaces and/or comments.
Cleaners are programming language specific.'
]

{ #category : 'accessing' }
MiCodeCleanerSettingPresenter class >> label [

	^ 'Code cleaning startegy'
]

{ #category : 'event handling' }
MiCodeCleanerSettingPresenter >> activate: aCodeCleaner [

	memento sourcesCleaner: aCodeCleaner
]

{ #category : 'layout' }
MiCodeCleanerSettingPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom
]

{ #category : 'building' }
MiCodeCleanerSettingPresenter >> helpForItem: aCodeCleaner [

	^ aCodeCleaner description
]

{ #category : 'testing' }
MiCodeCleanerSettingPresenter >> isCurrentValue: aCodeCleanerClass [

	^ aCodeCleanerClass class = memento sourcesCleaner class
]

{ #category : 'accessing' }
MiCodeCleanerSettingPresenter >> items [

	^ memento availableSourceCleaners
]

{ #category : 'building' }
MiCodeCleanerSettingPresenter >> labelForItem: aCodeCleanerClass [

	^ aCodeCleanerClass displayString
]
