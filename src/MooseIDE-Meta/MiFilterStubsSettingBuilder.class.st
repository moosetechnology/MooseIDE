Class {
	#name : #MiFilterStubsSettingBuilder,
	#superclass : #MiBooleanSettingBuilder,
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #default }
MiFilterStubsSettingBuilder >> defaultAction [

	^ [ :boolean | self manager filterStubs: boolean ]
]

{ #category : #default }
MiFilterStubsSettingBuilder >> defaultCurrentValue [

	^ self manager filterStubs
]

{ #category : #default }
MiFilterStubsSettingBuilder >> defaultHelp [

	^ 'When propagating the model should it filter out the stub entities or pass them along'
]

{ #category : #default }
MiFilterStubsSettingBuilder >> defaultInitialValue [

	^ true
]

{ #category : #default }
MiFilterStubsSettingBuilder >> defaultLabel [

	^ 'Filter out stubs?'
]
