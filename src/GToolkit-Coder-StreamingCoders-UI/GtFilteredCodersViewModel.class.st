Class {
	#name : #GtFilteredCodersViewModel,
	#superclass : #GtStreamingCodersViewModel,
	#instVars : [
		'highlighter'
	],
	#category : #'GToolkit-Coder-StreamingCoders-UI-Coder'
}

{ #category : #'api - accessing' }
GtFilteredCodersViewModel >> additionalFilters [
	<return: #Collection of: #GtSearchFilter>

	^ streamingCodersModel additionalFilters
]

{ #category : #'api - accessing' }
GtFilteredCodersViewModel >> compositeFilter [
	<return: #GtSearchFilter>

	^ streamingCodersModel compositeFilter
]

{ #category : #'private - notifying' }
GtFilteredCodersViewModel >> notifyFilterChanged [
	self announce: GtFilteredCodersViewModelFilterChanged new
]

{ #category : #'private - event handling' }
GtFilteredCodersViewModel >> onCodersStreamChanged: anAnnouncement [
	super onCodersStreamChanged: anAnnouncement.

	((anAnnouncement isDueTo: GtFilteredCodersFilterReason)
		or: [ anAnnouncement isDueTo: GtFilteredCodersAdditionalFiltersReason ])
			ifFalse: [ ^ self ].
			
	self onFilterChanged
]

{ #category : #'private - event handling' }
GtFilteredCodersViewModel >> onFilterChanged [
	self updateFiltersHighlighter.
	self notifyFilterChanged
]

{ #category : #'api - streaming coders model' }
GtFilteredCodersViewModel >> onStreamingCodersModelChanged [
	"Is sent when a new streamingCodersModel is assigned to the receiver.
	Note: #onStreamingCodersModelChanged is sent before #subscribeToStreamingCodersModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostStreamingCodersModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
	super onStreamingCodersModelChanged.

	self updateFiltersHighlighter
]

{ #category : #'private - update' }
GtFilteredCodersViewModel >> updateFiltersHighlighter [	
	highlighter := streamingCodersModel compositeFilter highlighter.
	coderViewModels valuesDo: [ :eachCoderViewModel |
		eachCoderViewModel highlighter: highlighter ]
]
