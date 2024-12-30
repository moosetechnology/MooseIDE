Class {
	#name : #MiExternalEditorOpenner,
	#superclass : #OSPlatformVisitor,
	#instVars : [
		'command',
		'pathString'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiExternalEditorOpenner class >> open: aPathString using: editorCommand [
	self new
		pathString: aPathString;
		command: editorCommand;
		visit
]

{ #category : #accessing }
MiExternalEditorOpenner >> command [

	^ command
]

{ #category : #accessing }
MiExternalEditorOpenner >> command: anObject [

	command := anObject
]

{ #category : #'as yet unclassified' }
MiExternalEditorOpenner >> open: aPathString using: editorCommand [
	self new
]

{ #category : #accessing }
MiExternalEditorOpenner >> pathString [

	^ pathString
]

{ #category : #accessing }
MiExternalEditorOpenner >> pathString: anObject [

	pathString := anObject
]

{ #category : #'private - ffi' }
MiExternalEditorOpenner >> privShellExecute: lpOperation file: lpFile parameters: lpParameters directory: lpDirectory show: nShowCmd [
	^ self ffiCall: #(
			FFIConstantHandle ShellExecuteA(
     				int 0, "Operation is not associated with a window"
     				char* lpOperation,
         			char* lpFile,
     				char* lpParameters,
     				char* lpDirectory,
        			int nShowCmd)) module: #shell32
]

{ #category : #'private - ffi' }
MiExternalEditorOpenner >> visitMacOS: aPlatform [
	LibC runCommand: ('{1} "{2}" &' format: {command . pathString})
]

{ #category : #'private - ffi' }
MiExternalEditorOpenner >> visitUnix: aPlatform [
	LibC runCommand: ('{1} "{2}" &' format: {command . pathString})
]

{ #category : #'private - ffi' }
MiExternalEditorOpenner >> visitWindows: aPlatform [

	self
		privShellExecute: 'open'
		file: ('"{1}"' format: { command })
		parameters: ('"{1}"' format: { pathString })
		directory: ''
		show: 5 "SW_SHOW : Activates the window and displays it in its current size and position."
]
