using System.Text;

namespace VolumeVaultInfra.Extensions;

public static class IEnumerableExtensions
{
    public static string ToSeparatedString(this IEnumerable<string> stringEnumerable)
    {
        StringBuilder stringBuilder = new();
        
        List<string> stringList = stringEnumerable.ToList();
        foreach (string text in stringList)
        {
            bool isLast = text.Equals(stringList.Last());
            
            stringBuilder.Append(text);
            if(!isLast)
                stringBuilder.Append(", ");
        }
        
        return stringBuilder.ToString();
    }
}