Class {
	#name : 'GtCoderCorrectionRequest',
	#superclass : 'GtSourceCoderAnnouncement',
	#instVars : [
		'fromIndex',
		'toIndex',
		'correctionString'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : 'accessing' }
GtCoderCorrectionRequest >> correctionString [
	^ correctionString
]

{ #category : 'accessing' }
GtCoderCorrectionRequest >> correctionString: anObject [
	correctionString := anObject
]

{ #category : 'accessing' }
GtCoderCorrectionRequest >> fromIndex [
	^ fromIndex
]

{ #category : 'accessing' }
GtCoderCorrectionRequest >> fromIndex: anObject [
	fromIndex := anObject
]

{ #category : 'accessing' }
GtCoderCorrectionRequest >> toIndex [
	^ toIndex
]

{ #category : 'accessing' }
GtCoderCorrectionRequest >> toIndex: anObject [
	toIndex := anObject
]
