Class {
	#name : #GtPharoDummyMethod,
	#superclass : #GtPharoDummy,
	#instVars : [
		'dummyClass',
		'realMethod',
		'selector',
		'protocol'
	],
	#category : #'GToolkit-Coder-Pharo-Examples-Dummies'
}

{ #category : #'api - inst vars' }
GtPharoDummyMethod >> anyInstVarName [
	<return: #Symbol>

	^ self dummyClass anyInstVarName
]

{ #category : #'api - class' }
GtPharoDummyMethod >> className [
	^ self dummyClass className
]

{ #category : #accessing }
GtPharoDummyMethod >> dummyClass [
	^ dummyClass
]

{ #category : #accessing }
GtPharoDummyMethod >> dummyClass: anObject [
	dummyClass := anObject
]

{ #category : #testing }
GtPharoDummyMethod >> isKeyword [
	^ self selector isKeyword
]

{ #category : #testing }
GtPharoDummyMethod >> isUnary [
	^ self selector isUnary
]

{ #category : #accessing }
GtPharoDummyMethod >> protocol [
	^ protocol
]

{ #category : #accessing }
GtPharoDummyMethod >> protocol: anObject [
	protocol := anObject
]

{ #category : #'api - class' }
GtPharoDummyMethod >> realClass [
	<return: #Class>

	^ self dummyClass realClass
]

{ #category : #accessing }
GtPharoDummyMethod >> realMethod [
	^ realMethod
]

{ #category : #accessing }
GtPharoDummyMethod >> realMethod: anObject [
	realMethod := anObject
]

{ #category : #accessing }
GtPharoDummyMethod >> selector [
	^ selector
]

{ #category : #accessing }
GtPharoDummyMethod >> selector: anObject [
	selector := anObject
]
