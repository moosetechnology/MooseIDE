"
I am the model of the report builder.

I store a collection of cell models.

You can instantiate me with a moose notebook file (.ston):

```
builder := MiReportBuilder instantiateWith: '/path/to/notebook.ston' on: (MooseModel root at: 1).
```

Once a notebook is loaded, you can execute the notebook and export the reslut:

```
builder exportToTextAt: '/path/to/your/notebook.md' asFileReference
```

See export protocole (instance side) for more export methods.
"
Class {
	#name : 'MiNotebookModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'mooseModel',
		'textEditedSource',
		'needToUpdate',
		'micDocument',
		'cellList',
		'context',
		'generatedDocument'
	],
	#category : 'MooseIDE-Export-Notebook',
	#package : 'MooseIDE-Export',
	#tag : 'Notebook'
}

{ #category : 'accessing' }
MiNotebookModel >> entities [

	^ mooseModel
]

{ #category : 'accessing' }
MiNotebookModel >> miSelectedItem [

	^ self entities
]

{ #category : 'actions' }
MiNotebookModel >> mooseModel: aMooseModel [

	mooseModel := aMooseModel
]
