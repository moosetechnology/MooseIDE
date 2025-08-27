Class {
	#name : 'MiDoubleClickSettingPresenter',
	#superclass : 'MiAbstractRadioButtonSettingPresenter',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiDoubleClickSettingPresenter class >> help [

	^ 'What happens when double-clicking on an entity? '
]

{ #category : 'accessing' }
MiDoubleClickSettingPresenter class >> label [

	^ 'Double click action'
]

{ #category : 'event handling' }
MiDoubleClickSettingPresenter >> activate: aCommand [

	memento doubleClickAction: aCommand
]

{ #category : 'building' }
MiDoubleClickSettingPresenter >> helpForItem: aCommand [

	^ aCommand description
]

{ #category : 'testing' }
MiDoubleClickSettingPresenter >> isCurrentValue: aCommand [

	^ aCommand class = memento doubleClickAction class
]

{ #category : 'accessing' }
MiDoubleClickSettingPresenter >> items [

	^ memento availableDoubleClickActions
]

{ #category : 'building' }
MiDoubleClickSettingPresenter >> labelForItem: aCommand [

	^ aCommand name
]
