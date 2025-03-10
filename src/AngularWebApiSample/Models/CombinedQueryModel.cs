using System.Collections.Generic;
using AngularWebApiSample.Attributes;

namespace AngularWebApiSample.Models;

[GenerateFrontendType]
public class CombinedQueryModel
{
    public int Id { get; set; }

#pragma warning disable MA0016 // Prefer return collection abstraction instead of implementation
    public List<SimpleModel> SimpleModels { get; internal set; } = new List<SimpleModel>();
#pragma warning restore MA0016 // Prefer return collection abstraction instead of implementation
}
