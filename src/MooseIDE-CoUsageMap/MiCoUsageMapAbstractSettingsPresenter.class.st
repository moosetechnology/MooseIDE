"
for common attributes
"
Class {
	#name : #MiCoUsageMapAbstractSettingsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'settings'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #accessing }
MiCoUsageMapAbstractSettingsPresenter >> settings [
	^ settings
]

{ #category : #accessing }
MiCoUsageMapAbstractSettingsPresenter >> settings: anObject [
	settings := anObject.
	self connectPresenters.
]
