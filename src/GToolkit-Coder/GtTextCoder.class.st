Class {
	#name : #GtTextCoder,
	#superclass : #GtTextualCoder,
	#instVars : [
		'styler'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - ast' }
GtTextCoder >> computeAst: theSourceString [
	^ theSourceString
]

{ #category : #'instance creation' }
GtTextCoder >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #'instance creation' }
GtTextCoder >> newSourceStylerFrom: anEditorElement [
	<return: #BlTextStyler>

	^ styler
]

{ #category : #accessing }
GtTextCoder >> styler [
	^ styler
]

{ #category : #accessing }
GtTextCoder >> styler: anObject [
	styler := anObject
]
