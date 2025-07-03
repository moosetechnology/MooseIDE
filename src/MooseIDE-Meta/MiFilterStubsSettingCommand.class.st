Class {
	#name : #MiFilterStubsSettingCommand,
	#superclass : #MiBooleanSettingCommand,
	#category : #'MooseIDE-Meta-Settings'
}

{ #category : #default }
MiFilterStubsSettingCommand class >> defaultDescription [

	^ 'When propagating the model should it filter out the stub entities or pass them along'
]

{ #category : #default }
MiFilterStubsSettingCommand class >> defaultName [

	^ 'Filter out stubs?'
]

{ #category : #accessing }
MiFilterStubsSettingCommand >> currentValue [

	^ self context filterStubs
]

{ #category : #execution }
MiFilterStubsSettingCommand >> execute: aBoolean [

	self context filterStubs: aBoolean
]
