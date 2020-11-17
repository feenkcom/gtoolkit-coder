"
!Coder
Coder is a set of components for creating and manipulating code.
!!Method coder
The smallest unit is the ${class:GtMethodCoder}$ which, as the name says, focuses on editing one single method.

${example:GtMethodCoderExamples>>#keywordSelectorCoder|noCode=|previewShow=#gtLiveFor:|previewHeight=150}$

The method coder can mold dynamically to fit the context of the current method. For example, when the method is annotated with ==<gtExample>==, the coder is embellished with the possibility to run the method as an example, and see the result as a label. This happens dynamically. Give it a try below.

${example:GtMethodCoderExamples>>#thisMethod|noCode=|previewShow=#gtLiveFor:|previewHeight=300}$
!!Filters
Method coders can be combined in different ways for different purposes. One of these purposes is searching. This is achieved by means of ${class:GtSearchMethodsFilter}$.

For example, below you see the result of a code query. Expanding the resulting method coders highlights the specific nodes that matched the query.

${example:GtSearchMethodFilterExamples>>#gtExamplePragmas|previewExpanded=|previewShow=#gtItemsFor:|codeExpanded=false}$

See ${class:GtSearchMethodFilterExamples}$ for more details.
"
Class {
	#name : #BaselineOfGToolkitCoder,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitCoder
}

{ #category : #baseline }
BaselineOfGToolkitCoder >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.8.148/src' ];
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.5/src' ];
			baseline: 'GToolkitAnnouncerUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.5/src' ];
			baseline: 'GToolkitCoderMetamodels' with: [
				spec repository: 'github://feenkcom/gtoolkit-coder:v0.8.211/src' ];
			baseline: 'GToolkitPager' with: [
				spec repository: 'github://feenkcom/gtoolkit-pager:v0.8.164/src' ];
			baseline: 'GToolkitPhlow' with: [
				spec repository: 'github://feenkcom/gtoolkit-phlow:v0.8.162/src' ].
		spec 
			package: 'GToolkit-Coder' with: [
				spec requires: #('Brick' 'GToolkitBasicUtility' 'GToolkitAnnouncerUtility' 'GToolkitCoderMetamodels' 'GToolkitPhlow' 'GToolkitPager' ). ];
			package: 'GToolkit-Coder-UI' with: [
				spec requires: #('GToolkit-Coder' 'Brick' 'GToolkitBasicUtility' 'GToolkitPhlow' 'GToolkitPager' ). ];
			package: 'GToolkit-Coder-AddOns' with: [
				spec requires: #('GToolkit-Coder' 'GToolkit-Coder-UI' ). ];
			package: 'GToolkit-Coder-Extensions' with: [
				spec requires: #('GToolkit-Coder' 'GToolkit-Coder-UI' 'GToolkit-Coder-AddOns' ). ];
			package: 'GToolkit-Coder-Examples-SystemS1';
			package: 'GToolkit-Coder-Examples' with: [
				spec requires: #('GToolkit-Coder' 'GToolkit-Coder-UI' 'GToolkit-Coder-AddOns' 'GToolkit-Coder-Examples-SystemS1' ). ]. ].

]
