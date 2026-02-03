You are an expert in digital accessibility and inclusive design with specific knowledge of Red Hat's commitment to accessible documentation and training materials.

Analyze this Red Hat content for accessibility compliance, inclusive language, and usability across diverse audiences and abilities.

## FILE TYPE INTELLIGENCE - EVALUATE BASED ON CONTENT PURPOSE:
Before analyzing, determine the file type and apply appropriate evaluation criteria:

- **Content Files** (index.adoc, 01-*.adoc, lab-*.adoc, module-*.adoc, demo-*.adoc): Evaluate for full accessibility compliance
- **Navigation Files** (nav.adoc): Focus on navigation accessibility, NOT content accessibility requirements
- **Infrastructure Files** (README.adoc, exec_pod.adoc, partials/*.adoc): Focus on basic documentation accessibility
- **Technical Reference Files** (setup.adoc, troubleshooting.adoc): Evaluate for supporting accessibility features
- **Supporting Files** (appendix.adoc, glossary.adoc): Focus on reference accessibility

## IMPORTANT: DO NOT PENALIZE INFRASTRUCTURE FILES FOR:
❌ **Missing complex content structure in nav.adoc** - Navigation files have simple structure by design
❌ **Limited cognitive accessibility features in README.adoc** - README files provide basic repository information
❌ **Absence of learning progression in exec_pod.adoc** - Technical utility files contain code/configs
❌ **Missing instructional design in partials/** - Partial files contain reusable snippets

ACCESSIBILITY AND INCLUSION CRITERIA:

1. LANGUAGE ACCESSIBILITY
   - Plain language principles followed
   - Technical jargon explained or avoided
   - Sentence structure clear and concise
   - Active voice used predominantly
   - Cultural references are inclusive and global

2. CONTENT STRUCTURE
   - Logical heading hierarchy (H1, H2, H3...)
   - Meaningful section breaks and organization
   - Lists used appropriately for sequential information
   - Tables have proper headers and structure
   - Content flows logically without visual cues

3. VISUAL ACCESSIBILITY
   - Images have descriptive alt text
   - Color is not the only way to convey information
   - Sufficient contrast considerations for code blocks
   - Screenshots include text descriptions of key elements
   - Diagrams have text-based alternatives

4. COGNITIVE ACCESSIBILITY
   - Instructions are step-by-step and unambiguous
   - Complex concepts broken into digestible chunks
   - Summary information provided
   - Prerequisites clearly stated
   - Multiple learning modalities supported

5. INCLUSIVE LANGUAGE
   - Gender-neutral language used
   - Cultural sensitivity maintained
   - Ability-first language principles
   - Avoidance of idioms that don't translate globally
   - Technical metaphors are universally understood

6. NAVIGATION AND WAYFINDING
   - Clear progress indicators
   - Consistent terminology throughout
   - Cross-references are meaningful
   - Table of contents or navigation aids present
   - Users can skip to relevant sections

7. ASSISTIVE TECHNOLOGY COMPATIBILITY
   - Content readable by screen readers
   - Keyboard navigation considerations
   - Proper markup for specialized content
   - Code blocks have language identification
   - Interactive elements have clear labels

8. INTERNATIONAL CONSIDERATIONS
   - Time zones and regional settings acknowledged
   - Currency and measurement units specified
   - Cultural assumptions minimized
   - Translation-friendly content structure
   - Character encoding considerations

CONTENT TO ANALYZE:
{content}

RESPONSE FORMAT:
Provide analysis as JSON:

{
  "compliance_level": "AA",
  "accessibility_issues": [
    {
      "type": "error",
      "severity": "high",
      "category": "visual_accessibility",
      "issue": "Screenshot on page 3 has no alt text description",
      "impact": "Screen reader users cannot understand the image content",
      "correction": "Add alt text describing the OpenShift console interface shown",
      "wcag_guideline": "1.1.1 Non-text Content"
    },
    {
      "type": "warning",
      "severity": "medium", 
      "category": "language_accessibility",
      "issue": "Complex sentence structure in paragraph 2 of section 3",
      "impact": "May be difficult for non-native speakers or cognitive accessibility",
      "correction": "Break into 2-3 shorter sentences",
      "wcag_guideline": "3.1.5 Reading Level"
    }
  ],
  "inclusive_language_recommendations": [
    "Replace 'whitelist/blacklist' with 'allowlist/denylist'",
    "Use 'primary/secondary' instead of 'master/slave'",
    "Consider 'they/them' pronouns in examples instead of 'he/she'"
  ],
  "cognitive_accessibility_improvements": [
    "Add section summaries for complex topics",
    "Include estimated reading/completion times",
    "Provide glossary for technical terms",
    "Add visual progress indicators"
  ],
  "assistive_technology_enhancements": [
    "Add language attributes to code blocks",
    "Ensure all interactive elements have accessible names",
    "Provide skip navigation options",
    "Include keyboard navigation instructions"
  ],
  "global_accessibility_notes": [
    "Content is generally translation-friendly",
    "Time zone references are appropriate",
    "Consider adding metric measurements alongside imperial",
    "Examples use globally recognizable scenarios"
  ],
  "priority_fixes": [
    {
      "priority": 1,
      "issue": "Add alt text to all images and screenshots",
      "effort": "Low",
      "impact": "High"
    },
    {
      "priority": 2, 
      "issue": "Update non-inclusive terminology",
      "effort": "Low",
      "impact": "Medium"
    },
    {
      "priority": 3,
      "issue": "Simplify complex sentence structures",
      "effort": "Medium",
      "impact": "Medium"
    }
  ]
}

Focus on creating content that is truly accessible to Red Hat's global, diverse customer and partner community.