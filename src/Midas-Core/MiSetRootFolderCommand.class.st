Class {
	#name : #MiSetRootFolderCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #default }
MiSetRootFolderCommand class >> defaultName [
	^ 'Set Root Folder'
]

{ #category : #testing }
MiSetRootFolderCommand >> canBeExecuted [
	^ self context miSelectedItem isMooseObject
]

{ #category : #executing }
MiSetRootFolderCommand >> execute [
	| folder |
	folder := UITheme builder
		chooseDirectory:
			'Choose the root folder for the sources of '
				, self context miSelectedItem name.
	folder
		ifNotNil: [ self context miSelectedItem rootFolder: folder fullName ]
]
