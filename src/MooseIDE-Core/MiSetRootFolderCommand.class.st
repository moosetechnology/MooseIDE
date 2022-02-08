Class {
	#name : #MiSetRootFolderCommand,
	#superclass : #MiModelUtilityCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiSetRootFolderCommand class >> defaultIconName [
	^ #glamorousFolder
]

{ #category : #default }
MiSetRootFolderCommand class >> defaultName [
	^ 'Set Root Folder'
]

{ #category : #executing }
MiSetRootFolderCommand >> execute [
	(UITheme builder
		chooseDirectory: 'Choose the root folder for the sources of ' , self model name)
		ifNotNil: [ :folder | self model rootFolder: folder fullName ]
]
