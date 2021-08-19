Class {
	#name : 'GtCoderAstChanged',
	#superclass : 'GtCoderAnnouncement',
	#instVars : [
		'ast'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : 'accessing' }
GtCoderAstChanged >> ast [
	^ ast
]

{ #category : 'accessing' }
GtCoderAstChanged >> ast: anObject [
	ast := anObject
]
