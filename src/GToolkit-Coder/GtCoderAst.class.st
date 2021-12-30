Class {
	#name : #GtCoderAst,
	#superclass : #Object,
	#instVars : [
		'ast',
		'epoch',
		'sourceString'
	],
	#category : #'GToolkit-Coder-Ast'
}

{ #category : #accessing }
GtCoderAst >> ast [

	^ ast
]

{ #category : #accessing }
GtCoderAst >> ast: anObject [

	ast := anObject
]

{ #category : #accessing }
GtCoderAst >> epoch [

	^ epoch
]

{ #category : #accessing }
GtCoderAst >> epoch: anObject [

	epoch := anObject
]

{ #category : #accessing }
GtCoderAst >> sourceString [
	<return: #GtCoderSourceString>

	^ sourceString
]

{ #category : #accessing }
GtCoderAst >> sourceString: aGtCoderSourceString [
	sourceString := aGtCoderSourceString
]
