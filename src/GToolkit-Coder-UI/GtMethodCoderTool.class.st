Class {
	#name : #GtMethodCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'compiledMethod'
	],
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #'instance creation' }
GtMethodCoderTool class >> compiledMethod: aMethod [ 
	^ self new compiledMethod: aMethod
]

{ #category : #accessing }
GtMethodCoderTool >> compiledMethod [
	^ compiledMethod
]

{ #category : #accessing }
GtMethodCoderTool >> compiledMethod: anObject [
	compiledMethod := anObject
]

{ #category : #converting }
GtMethodCoderTool >> newCoder [
	^ GtCoder forMethod: self compiledMethod
]

{ #category : #accessing }
GtMethodCoderTool >> object [
	"compatibility method for ${GLMBlocObjectToSelect}$"
	^ self compiledMethod
]
