Class {
	#name : #GtCoderEvaluationAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'coder',
		'result'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCoderEvaluationAnnouncement class >> forCoder: aCoder result: anObject [
	^ self new
		coder: aCoder;
		result: anObject;
		yourself
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> coder: methodCoder [
	coder := methodCoder
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> result [
	^ result
]

{ #category : #accessing }
GtCoderEvaluationAnnouncement >> result: anObject [
	result := anObject
]
