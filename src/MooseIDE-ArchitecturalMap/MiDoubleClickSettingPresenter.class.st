Class {
	#name : 'MiDoubleClickSettingPresenter',
	#superclass : 'MiAbstractRadioButtonSettingPresenter',
	#category : 'MooseIDE-ArchitecturalMap',
	#package : 'MooseIDE-ArchitecturalMap'
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

	configuration doubleClickAction: aCommand
]

{ #category : 'building' }
MiDoubleClickSettingPresenter >> helpForItem: aCommand [

	^ aCommand description
]

{ #category : 'testing' }
MiDoubleClickSettingPresenter >> isCurrentValue: aCommand [

	^ aCommand class = configuration doubleClickAction class
]

{ #category : 'accessing' }
MiDoubleClickSettingPresenter >> items [

	^ configuration availableDoubleClickActions
]

{ #category : 'building' }
MiDoubleClickSettingPresenter >> labelForItem: aCommand [

	^ aCommand name
]
