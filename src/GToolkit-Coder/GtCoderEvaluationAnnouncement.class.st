Class {
	#name : #GtCoderEvaluationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coder',
		'value',
		'isException'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #'instance creation' }
GtCoderEvaluationAnnouncement class >> forCoder: aCoder value: anObject isException: aBoolean [
	^ self new
		coder: aCoder;
		value: anObject;
		isException: aBoolean;
		yourself
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> coder: aSourceCoder [
	coder := aSourceCoder
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> isException [
	^ isException
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> isException: aBoolean [
	isException := aBoolean
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> value [
	^ value
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> value: anObject [
	value := anObject
]
